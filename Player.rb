# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'

# 玩家類別藍圖，負責偵測玩家的輸入，並更新玩家的位置數據
class Player
  # 賦權以取用其他實例的資料
  attr_accessor :direction
  attr_accessor :position

  # 負責初始化相關數據，會自動被呼叫
  def initialize
    @direction = 'down'
    @position = [[5, 0], [5, 1], [5, 2], [5, 3]]
    @pre_generate_position = [-1,-1]
  end

  # 每次遊戲迴圈都會被呼叫
  def update
    update_position
    draw_snake
  end

  # 每次遊戲迴圈都會更新玩家位置，前進一格！
  def update_position
    $player.position.shift

    # 判斷目前玩家的方向，上下左右
    case @direction
    # 如果是上的話
    when  'up'
      $player.position.push([$player.position.last[0], $player.position.last[1] - 1])
      if($player.position.last[1] < 0)
        $player.position.last[1] = MAP_HEIGHT_UNIT_NUM
      end
    # 如果是下的話
    when  'down'
      $player.position.push([$player.position.last[0], $player.position.last[1] + 1])
      if($player.position.last[1] > MAP_HEIGHT_UNIT_NUM)
        $player.position.last[1] = 0
      end
    # 如果是右的話
    when  'right'
      $player.position.push([$player.position.last[0] + 1, $player.position.last[1]])
      if($player.position.last[0] > MAP_WIDTH_UNIT_NUM)
        $player.position.last[0] = 0
      end
    # 如果是左的話
    when  'left'
      $player.position.push([$player.position.last[0] - 1, $player.position.last[1]])
      if($player.position.last[0] < 0)
        $player.position.last[0] = MAP_WIDTH_UNIT_NUM
      end
    end
  end

  # 繪製蛇的身體
  def draw_snake
    @position.each do |position|
      Square.new(x: position[0] * UNIT_SIZE, y: position[1] * UNIT_SIZE, size: UNIT_SIZE-1, color: 'white')
    end
  end
end

# 偵測鍵盤按鍵的輸入
on :key_down do |event|
  # 如果按下鍵盤的上下左右
  if ['up', 'down', 'left', 'right'].include?(event.key)
    case $player.direction
    when  'up'
      if event.key != 'down'
        $player.direction = event.key
      end
    when  'down'
      if event.key != 'up'
        $player.direction = event.key
      end
    when  'right'
      if event.key != 'left'
        $player.direction = event.key
      end
    when  'left'
      if event.key != 'right'
        $player.direction = event.key
      end
    end
  # 如果按下鍵盤的ENTER
  elsif event.key == 'return'
    $game_rule.on_enter_down
  end
end