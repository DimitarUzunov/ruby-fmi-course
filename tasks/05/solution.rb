require 'digest/sha1'

class Success
  attr_reader :message, :result

  def initialize(success, message, result = nil)
    @success = success
    @message = message
    @result = result
  end

  def success?
    @success
  end

  def error?
    not success?
  end
end

class ObjectStore
  class Commit
    attr_reader :date, :message, :hash

    def initialize(message, objects)
      @date = Time.now
      @message = message
      @hash = Digest::SHA1.hexdigest "#{formatted_date}#{message}"
      @objects = objects
    end

    def objects
      @objects.values
    end

    def objects_hash
      @objects
    end

    def formatted_date
      @date.strftime("%a %b %d %H:%M %Y %z")
    end

    def to_s
      "Commit #{@hash}\nDate: #{formatted_date}\n\n\t#{@message}"
    end
  end

  class Branches
    class Branch
      attr_reader :name
      attr_accessor :commits

      def initialize(name, commits = [])
        @name = name
        @commits = commits
      end
    end

    attr_reader :active_branch

    def initialize
      @branches = {'master' => Branch.new('master')}
      @active_branch = @branches['master']
    end

    def create(branch_name)
      if branch_exists?(branch_name)
        Success.new(false, "Branch #{branch_name} already exists.")
      else
        new_branch = Branch.new(branch_name, @active_branch.commits.clone)
        @branches[branch_name] = new_branch

        Success.new(true, "Created branch #{branch_name}.")
      end
    end

    def checkout(branch_name)
      if branch_exists?(branch_name)
        @active_branch = @branches[branch_name]

        Success.new(true, "Switched to branch #{branch_name}.")
      else
        Success.new(false, "Branch #{branch_name} does not exist.")
      end
    end

    def remove(branch_name)
      if not branch_exists?(branch_name)
        Success.new(false, "Branch #{branch_name} does not exist.")
      elsif active_branch?(branch_name)
        Success.new(false, 'Cannot remove current branch.')
      else
        @branches.delete(branch_name)

        Success.new(true, "Removed branch #{branch_name}.")
      end
    end

    def list
      message = @branches.sort.map do |_, branch|
        "#{active_branch?(branch.name) ? '*' : ' '} #{branch.name}"
      end.join("\n")

      Success.new(true, message)
    end

    private

    def branch_exists?(branch_name)
      @branches[branch_name]
    end

    def active_branch?(branch_name)
      @active_branch.name == branch_name
    end
  end

  def initialize
    @branches = Branches.new
    @staging_area = {}
    @objects_to_remove = []
  end

  def self.init
    repository = self.new
    repository.instance_eval(&Proc.new) if block_given?
    repository
  end

  def branch
    @branches
  end

  def add(name, object)
    @staging_area[name] = object
    Success.new(true, "Added #{name} to stage.", object)
  end

  def remove(name)
    if head.error? or not head.result.objects_hash[name]
      Success.new(false, "Object #{name} is not committed.")
    else
      object = head.result.objects_hash[name]

      @staging_area[name] = object
      @objects_to_remove << name

      Success.new(true, "Added #{name} for removal.", object)
    end
  end

  def commit(message)
    if @staging_area.empty?
      Success.new(false, 'Nothing to commit, working directory clean.')
    else
      count = @staging_area.size

      branch.active_branch.commits << Commit.new(message, commit_objects)
      clear_staging_area

      Success.new(true, "#{message}\n\t#{count} objects changed", head.result)
    end
  end

  def checkout(commit_hash)
    commit_hashes = branch.active_branch.commits.map { |commit| commit.hash }
    commit_index = commit_hashes.find_index(commit_hash)
    if commit_index
      commits = branch.active_branch.commits
      commits.pop(commits.size - commit_index - 1)

      Success.new(true, "HEAD is now at #{commit_hash}.", head.result)
    else
      Success.new(false, "Commit #{commit_hash} does not exist.")
    end
  end

  def log
    if branch.active_branch.commits.empty?
      branch_name = branch.active_branch.name
      Success.new(false, "Branch #{branch_name} does not have any commits yet.")
    else
      message = branch.active_branch.commits.reverse.map(&:to_s).join("\n\n")
      Success.new(true, message)
    end
  end

  def head
    if branch.active_branch.commits.empty?
      branch_name = branch.active_branch.name
      Success.new(false, "Branch #{branch_name} does not have any commits yet.")
    else
      last_commit = branch.active_branch.commits.last
      Success.new(true, last_commit.message, last_commit)
    end
  end

  def get(name)
    if head.error? or not head.result.objects_hash[name]
      Success.new(false, "Object #{name} is not committed.")
    else
      Success.new(true, "Found object #{name}.", head.result.objects_hash[name])
    end
  end

  private

  def commit_objects
    head_objects = head.success? ? head.result.objects_hash : {}
    objects = head_objects.merge(@staging_area)
    @objects_to_remove.each { |name| objects.delete(name) }

    objects
  end

  def clear_staging_area
    @staging_area.clear
    @objects_to_remove.clear
  end
end
