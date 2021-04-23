class Animation
  def initialize(frames : Array(String), duration : Float64, cycles : Int32)
    @frames = frames
    @duration = duration
    @cycles = cycles
  end

  def animate
    @cycles.times do |i|
      @frames.each do |frame|
        print frame
        sleep @duration
        system "clear"
      end
    end
  end
end
