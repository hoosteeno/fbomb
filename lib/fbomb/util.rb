module Util
  def paths_for(*args)
    path = args.flatten.compact.join('/')
    path.gsub!(%r|[.]+/|, '/')
    path.squeeze!('/')
    path.sub!(%r|^/|, '')
    path.sub!(%r|/$|, '')
    paths = path.split('/')
  end

  def absolute_path_for(*args)
    ('/' + paths_for(*args).join('/')).squeeze('/')
  end

  def absolute_prefix_for(*args)
    absolute_path_for(*args) + '/'
  end

  def path_for(*args)
    paths_for(*args).join('/').squeeze('/')
  end

  def prefix_for(*args)
    path_for(*args) + '/'
  end

  def normalize_path(arg, *args)
    absolute_path_for(arg, *args)
  end

  def indent(chunk, n = 2)
    lines = chunk.split %r/\n/
    re = nil
    s = ' ' * n
    lines.map! do |line|
      unless re
        margin = line[%r/^\s*/]
        re = %r/^#{ margin }/
      end
      line.gsub re, s 
    end.join("\n")
  end

  def unindent(chunk)
    lines = chunk.split %r/\n/
    indent = nil
    re = %r/^/ 
    lines.map! do |line|
      unless indent 
        indent = line[%r/^\s*/]
        re = %r/^#{ indent }/
      end
      line.gsub re, ''
    end.join("\n")
  end

  def columnize(buf, opts = {})
    width = Util.getopt 'width', opts, 80
    indent = Util.getopt 'indent', opts
    indent = Fixnum === indent ? (' ' * indent) : "#{ indent }"
    column = []
    words = buf.split %r/\s+/o
    row = "#{ indent }"
    while((word = words.shift))
      if((row.size + word.size) < (width - 1))
        row << word
      else
        column << row
        row = "#{ indent }"
        row << word
      end
      row << ' ' unless row.size == (width - 1)
    end
    column << row unless row.strip.empty?
    column.join "\n"
  end

  def getopt(opt, hash, default = nil)
    keys = opt.respond_to?('each') ? opt : [opt]

    keys.each do |key|
      return hash[key] if hash.has_key? key
      key = "#{ key }"
      return hash[key] if hash.has_key? key
      key = key.intern
      return hash[key] if hash.has_key? key
    end

    return default
  end

  extend(Util)
end
