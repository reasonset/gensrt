class Duration
  def initialize current=nil
    @current = current || {
      h: 0,
      m: 0,
      s: 0,
      ms: 0
    }
  end

  def format duration
    s = duration[:ms] / 1000
    duration[:ms] = duration[:ms] % 1000
    duration[:s] += s
    m = duration[:s] / 60
    duration[:s] = duration[:s] % 60
    duration[:m] += m
    h = duration[:s] / 60
    duration[:m] = duration[:m] % 60
    duration[:h] += h

    duration
  end

  def +(duration)
    current = @current.clone
    if String === duration
      if /,(\d\d\d)$/ === duration
        current[:ms] += $1.to_i
        duration = $`
      end
      x = duration.split(":")
      s = x.pop
      m = x.pop
      h = x.pop
      current[:s] += s.to_i if s
      current[:m] += m.to_i if m
      current[:h] += h.to_i if h
    else
      current[:s] += duration.to_i
    end

    Duration.new(format current)
  end

  def set duration
    if String === duration
      if /,(\d\d\d)$/ === duration
        @current[:ms] = $1.to_i
        duration = $`
      end
      x = duration.split(":")
      s = x.pop
      m = x.pop
      h = x.pop
      @current[:s] = s.to_i if s
      @current[:m] = m.to_i if m
      @current[:h] = h.to_i if h
    else
      @current[:s] = duration.to_i
    end

    @current = format @current
    self.clone
  end

  def to_s
    sprintf("%02d:%02d:%02d,%03d", @current[:h], @current[:m], @current[:s], @current[:ms])
  end
end

class Interpreter
  def initialize
    @duration = Duration.new
    @counter = 1
    @subs = []
    @default_duration = 5
  end

  def parse par
    sym = par[0]
    length = @default_duration
    case sym
    when "#", "@", "="
      cline = par.split("\n")
      cline[0].scan(/([@#=])([0-9:,]+)/) do |cmd|
        case cmd[0]
        when "@"
          @duration.set cmd[1]
        when "#"
          length = cmd[1].to_i
        when "="
          @default_duration = cmd[1].to_i
        end
      end
      par = cline[1..].join("\n")
    end

    if par && !par.empty?
      next_duration = @duration + length
      lines = []
      lines.push @counter
      lines.push sprintf("%s --> %s", @duration, next_duration)
      lines.push par.strip
      @subs.push lines.join("\n")
      @duration = next_duration
      @counter += 1
    end
  end

  def to_s
    puts @subs.join("\n\n")
  end
end

i = Interpreter.new

while x = ARGF.gets("")
  i.parse x
end

puts i.to_s
