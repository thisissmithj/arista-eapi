class MockCli
  @@configure = ['username', 'configuretest']
  @@default= ['enable']
  @@enable = ['configure']

  def initialize()
    @running_config = []
    @default = true
    @enable = false
    @configure = false
  end

  def run(inputs=[])
    # Simplify way of getting the 'command', this should be parse as an
    # expression. Right now first word is the command, anything else follow
    # is the parameter
    tokens = tokenize(inputs.first)
    if valid_input?(tokens.first)
      first = tokens.shift
      self.send first, inputs.first
    else
      invalid_input(tokens.first)
    end
  end

  def tokenize(input)
    input.split
  end

  def successful
    '{}'
  end

  def invalid_input(input)
    'Invalid input'
  end

  def invalid_command(input)
    'Incomplete command'
  end

  def username(input)
    # Regex for now. CLI parsing is preferred, WIP in treetop branch
    standard = /username[\s]+([a-zA-Z\-]+)[\s]+role[\s]+([a-zA-Z\-]+)[\s]+secret[\s]+([\d])+[\s]+([a-zA-Z\-]+)/.match(input)
    sshkey = /username[\s]+([a-zA-Z\-]+)[\s]+sshkey[\s]+(.*)/.match(input)

    if standard
      @running_config << input
      return successful
    elsif sshkey
      @running_config << input
      return successful
    else
      invalid_command(input)
    end
  end

  def default?
    return @default
  end

  def enable?
    return @enable
  end

  def configure?
    return @configure
  end

  def default(*p)
    @enable = false
    @configure = false
    @default = true
  end

  def enable(*p)
    @enable = true
    @configure = false
    @default = false

  end

  def configure(*p)
    @enable = false
    @configure = true
    @default = false
  end

  def valid_input?(input)
    #puts "-------------------------------"
    #puts "DEBUG: input #{input}"
    #puts "DEBUG: default #{default?}"
    #puts "DEBUG: enable #{enable?}"
    #puts "DEBUG: configure #{configure?}"
    #puts "-------------------------------"

    case
    when default?
      if @@default.include?(input)
        true
      else
        false
      end
    when enable?
       if @@enable.include?(input)
        true
      else
        false
      end
    when configure?
       if @@configure.include?(input)
        true
      else
        false
      end
    end
  end
end
