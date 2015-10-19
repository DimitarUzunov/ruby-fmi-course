def complement(f)
  ->(*parameters) { not f.call(*parameters) }
end

def compose(f, g)
  ->(*parameters) { f.call(g.call(*parameters)) }
end
