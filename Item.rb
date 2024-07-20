# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'

class Item
    # 賦權以取用其他實例的資料
  attr_accessor :item_position

  # 負責初始化相關數據，會自動被呼叫
  def initialize
    @item_position = [10, 10]
    @is_item_exist = false
  end

  # 每次遊戲迴圈都會被呼叫
  def update
    draw_item
    detect_eat_item
  end

  # 繪製道具於視窗上
  def draw_item
    Square.new(x: $item.item_position[0] * UNIT_SIZE, y: $item.item_position[1] * UNIT_SIZE, size: UNIT_SIZE-1, color: 'red')
  end

  # 重新生成道具，使他出現在隨機位置
  def regenerate_item
    $item.item_position[0] = rand(MAP_WIDTH_UNIT_NUM)
    $item.item_position[1] = rand(MAP_HEIGHT_UNIT_NUM)
  end

  # 檢查玩家是否有吃到道具
  def detect_eat_item
    if $player.position.last == $item.item_position
      $player.position.unshift($player.position.first)
      $game_rule.add_score
      regenerate_item
    end
  end
end
