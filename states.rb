# frozen_string_literal: true

# Base class for states
class State
  attr_accessor :context

  # @abstract
  def action
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# No power state
class PowerOffState < State
  def action
    'No power'
  end
end

# Turned on state
class ReadyState < State
  def action
    'Ready'
  end
end

# Boiling water state
class BoilingWaterState < State
  def action
    'Boiling water'
  end
end

# Pouring milk state
class PouringMilkState < State
  def action
    'Pouring milk'
  end
end
