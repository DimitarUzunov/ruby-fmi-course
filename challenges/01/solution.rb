def complement(f)
  parameters = f.parameters.map { |_, name| name }
  ->(*parameters) { not f.call(*parameters) }
end

def compose(f, g)
  parameters = g.parameters.map { |_, name| name }
  ->(*parameters) { f.call(g.call(*parameters)) }
end
