require 'fileutils'

class ClockExporter
  def initialize(path)
    self.path = path
  end

  def set(clock)
    self.number = clock.number
    if should_start?(clock)
      self.countdown_thread = new_countdown(clock.milliseconds / 1000)
    elsif should_finish?(clock)
      countdown_thread.exit
    end
    self.running = clock.running
  end

  private

  attr_accessor :path, :number, :running, :countdown_thread

  def running?
    !!running
  end

  def new_countdown(seconds)
    Thread.new do
      loop do
        sleep 1
        seconds -= 1 if seconds > 0
        write(seconds)
      end
    end
  end

  def write(seconds)
    FileUtils.mkdir_p(path)
    File.open(path + '/time.txt', 'w') { |f| f << format_time(seconds) }
    File.open(path + '/number.txt', 'w') { |f| f << number }
  end

  def format_time(seconds)
    Time.at(seconds).strftime('%M:%S')
  end

  def should_start?(clock)
    !running? && clock.running
  end

  def should_finish?(clock)
    running? && !clock.running
  end
end
