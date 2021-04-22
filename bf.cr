class BrainFuck
  @code : String
  @code_ptr : Int32
  @code_len : Int32
  @buff : Array(Int32)
  @buff_ptr : Int32
  @code_ptr_stack : Array(Int32)
  @goto_pairs : Hash(Int32, Int32)

  def initialize(source : String)
    @code = parse(source)
    @code_ptr = 0
    @code_len = @code.size
    @buff = Array.new(30000, 0)
    @buff_ptr = 0
    @code_ptr_stack = [] of Int32
    @goto_pairs = pairs
  end

  def execute
    until @code_ptr >= @code_len
      step
    end
  end

  private def parse(source : String) : String
    source.gsub(/[^+-><.,\[\]]+/, "")
  end

  private def pairs
    stack = [] of Int32
    res = {} of Int32 => Int32

    @code_len.times do |i|
      op = @code[i]
      
      case op
      when '['
        stack.push(i)
      when ']'
        res[stack.pop] = i
      end
    end

    res
  end

  private def step
    op = @code[@code_ptr]
    
    case op
    when '+'
      buff_incr
    when '-'
      buff_decr
    when '>'
      buff_ptr_incr
    when '<'
      buff_ptr_decr
    when '.'
      print_buff
    when ','
      get_buff
    when '['
      goto_loopend
    when ']'
      goto_loopstart
    end

    @code_ptr += 1
  end

  private def buff_incr
    @buff[@buff_ptr] += 1
  end

  private def buff_decr
    @buff[@buff_ptr] -= 1
  end

  private def buff_ptr_incr
    @buff_ptr += 1
  end

  private def buff_ptr_decr
    @buff_ptr -= 1
  end

  private def print_buff
    print @buff[@buff_ptr].chr
  end

  private def get_buff
    @buff[@buff_ptr] = gets.to_s.to_i
  end

  private def goto_loopend
    if @buff[@buff_ptr] == 0
      @code_ptr = @goto_pairs[@code_ptr]
    else
      @code_ptr_stack.push(@code_ptr)
    end
  end

  private def goto_loopstart
    @code_ptr = @code_ptr_stack.pop - 1
  end
end

def main
  str = "+++++++++[>++++++++<-]>+++++++.-------.-------.<+++++++++[>++<-]>++++++.<+++++++++[>-<-]>-.++++++.<+++++++++[>-<-]>-----.++++++++.<+++++++++[>+<-]>++.<+++++++++[>--<-]>-------.++++++++.++++.<+++++++++[>-<-]>---.<+++++++++[>++<-]>.++."

  BrainFuck.new(str).execute # OHAYOUGOZAIMASU
end

main()
