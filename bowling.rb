class Frame

    LAST = 10

    TOTAL_PINS = 10

    attr_accessor :num, :evaluation, :remaining, :status, :first_shot, :second_shot, :bonus

    def initialize(num)
        @num = num
        @status = 'ongoing...'
        @evaluation = 'initial'
        @remaining = TOTAL_PINS
        @first_shot = nil
        @second_shot = nil
        @bonus = nil
    end

    def shoot(pins)
      @first_shot ? @second_shot = pins : @first_shot = pins 
      @remaining -= pins
      if @remaining == 0 || (@first_shot && @second_shot)
        @status = 'complete'
      end
      award_bonuses 
    end  

    def strike?
      @first_shot == TOTAL_PINS
    end

    def spare?
      !strike? && @remaining == 0
    end

    def award_bonuses
      if strike?
        @bonus = 2
      elsif spare?
        @bonus = 1
      elsif @first_shot && @second_shot
        @bonus = 0
      else
        @bonus = nil
      end
    end

end

class Board

    def initialize
        @frames = []
        @points_per_frame = []
        @display_per_frame = []
        @bonus_counters = []
        new_frame()
    end

    def score
      @points_per_frame[0...Frame::LAST].flatten.reduce(:+)
    end

    def display
      show = ''
      @display_per_frame.each do |df|
        show << df.join(' ')
        show << ','
      end
      show.chop
    end

    def roll(pins)
      return if game_over?
      return false if accidental_shot?(pins)
      current_frame = @frames.last
      current_frame.shoot(pins)
      fill_display(current_frame,pins)
      calculate_points(current_frame,pins)
      new_frame() if @frames.last.status == 'complete' && !complete?
    end

    def new_frame
      @frames << Frame.new(@frames.length + 1)
    end

    def complete?
      @frames[Frame::LAST-1].evaluation == 'done' if @frames[Frame::LAST-1]
    end

    def game_over?
      if complete?
        puts "Stop rolling. The game is over." 
        true
      end
    end

    def accidental_shot?(pins)
      if pins > @frames.last.remaining
        puts "Please retry. The pins cannot exceed the remaining value."
        true
      end
    end

    def fill_display(current_frame, pins)
      cf_num = current_frame.num-1
      @display_per_frame[cf_num] = [] if @display_per_frame[cf_num].nil?
      if current_frame.strike?
        @display_per_frame[cf_num] << 'X'
      elsif current_frame.spare?  
        @display_per_frame[cf_num] << '/'
      elsif pins == 0
        @display_per_frame[cf_num] << '-'
      else
        @display_per_frame[cf_num] << pins
      end
    end

    def calculate_points(current_frame,pins)
        cf = current_frame
        cf_num = cf.num-1
        @points_per_frame[cf_num] = [] if @points_per_frame[cf_num].nil?
        @points_per_frame[cf_num] << pins
        add_bonus_points(current_frame,pins)
    end
      
    def add_bonus_points(current_frame,pins)
      @bonus_counters.each_with_index do |bc,idx|
        if bc && bc > 0
          @points_per_frame[idx] << pins
          bc -= 1
          @bonus_counters[idx] = bc
        end
        if bc == 0
          @frames[idx].evaluation = 'done'
        end
      end
      @bonus_counters[current_frame.num - 1] = current_frame.bonus
    end

end

def rolls_to_points(rolls)
  points = []
  rolls.each_with_index do |p,idx|
    if p == "X"
      points[idx] = 10
    elsif p == "/"
      points[idx] = 10 - points[idx-1]
    elsif p == '-'
      points[idx] = 0
    else
      points[idx] = p.to_i
    end
  end
  points
end

def frames_to_rolls(frames)
  result = frames.chars
  result.each_with_index do |r,i|
    result.delete_at(i) if r == " "
  end
  result
end

def bowling_score(frames)
  rolls = frames_to_rolls(frames)
  points = rolls_to_points(rolls)
  bowling = Board.new()
  points.each do |p|
    bowling.roll(p)
  end
  puts bowling.display
  return bowling.score
end


game1 = 'X X X X X X X X X XXX'
game2 = '11 11 11 11 11 11 11 11 11 11'
game3 = '2/ 17 45 36 X 45 1/ 72 27 33'
game4 = '36 17 8/ 44 54 62 23 43 9- 3/4'
game5 = '1- 1- 1- 1- 1- 1- 1- 1- 1- 1-'


puts bowling_score(game1)
puts bowling_score(game2)
puts bowling_score(game3)
puts bowling_score(game4)
puts bowling_score(game5)

