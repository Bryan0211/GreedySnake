readme.md

### gamerule.rb

```ruby
class GameRule
  attr_accessor :game_state, :score

  def initialize
    @game_state = 'wait'  # 初始化遊戲狀態
    @score = 0            # 初始化分數
  end

  def update
    detect_death  # 檢查玩家是否死亡
  end

  def detect_death
    # Ruby 中的 each 方法類似於 JS 中的 forEach
    $player.position[0...-1].each do |element|
      if element == $player.position.last
        $game_rule.game_state = 'death'  # 如果玩家撞到自己，遊戲狀態變為死亡
        break
      end
    end
  end

  def on_enter_down
    case $game_rule.game_state
    when 'wait'
      start  # 開始遊戲
    when 'playing'
      exit  # 退出遊戲
    when 'death'
      restart  # 重啟遊戲
    end
  end

  def start
    $game_rule.game_state = 'playing'  # 將遊戲狀態設為進行中
  end

  def restart
    $main = Main.new  # 重新初始化主遊戲
    start  # 開始遊戲
  end

  def exit
    Window.close  # 關閉遊戲窗口
  end

  def add_score
    $game_rule.score += 1  # 增加分數
  end
end
```

### item.rb

```ruby
class Item
  attr_accessor :item_position

  def initialize
    @item_position = [10, 10]  # 初始化食物位置
    @is_item_exist = false     # 食物是否存在的標誌
  end

  def update
    draw_item  # 繪製食物
    detect_eat_item  # 檢測是否吃到食物
  end

  def draw_item
    # Ruby2D 的 Square 類似於 JS 的 Canvas 繪製方法
    Square.new(x: $item.item_position[0] * UNIT_SIZE, y: $item.item_position[1] * UNIT_SIZE, size: UNIT_SIZE-1, color: 'red')
  end

  def generate_item
    # Ruby 中的 rand 方法類似於 JS 中的 Math.random
    $item.item_position[0] = rand(MAP_WIDTH_UNIT_NUM)
    $item.item_position[1] = rand(MAP_HEIGHT_UNIT_NUM)
  end

  def detect_eat_item
    if $player.position.last == $item.item_position
      # 在蛇吃到食物後，將蛇的位置加長一格
      $player.position.unshift($player.position.first)
      $game_rule.add_score  # 增加分數
      generate_item  # 生成新食物
    end
  end
end
```

### main.rb

```ruby
class Main
  def initialize
    # 初始化地圖、玩家、遊戲規則、提示和食物
    $map = Map.new
    $player = Player.new
    $game_rule = GameRule.new
    $tip = Tip.new
    $item = Item.new
  end

  def game_loop
    if $game_rule.game_state == 'playing'
      # 更新遊戲規則、玩家、食物和提示
      $game_rule.update
      $player.update
      $item.update
      $tip.update
    end
    $tip.draw_tip  # 繪製提示
  end
end

$main = Main.new

update do
  clear
  $main.game_loop  # 執行遊戲主循環
end

show  # 顯示遊戲窗口
```

### map.rb

```ruby
UNIT_SIZE = 20
MAP_WIDTH = 640
MAP_HEIGHT = 480
MAP_WIDTH_UNIT_NUM = MAP_WIDTH / UNIT_SIZE
MAP_HEIGHT_UNIT_NUM = MAP_HEIGHT / UNIT_SIZE

class Map
  def initialize
    # 設置窗口標題和背景顏色
    Window.set(title: "Greedy Snake", width: MAP_WIDTH, height: MAP_HEIGHT)
    Window.set(background: 'navy')
  end
end
```

### player.rb

```ruby
class Player
  attr_accessor :direction, :position

  def initialize
    @direction = 'down'  # 初始方向為向下
    @position = [[5, 0], [5, 1], [5, 2], [5, 3]]  # 初始位置
  end

  def update
    update_position  # 更新位置
    draw_snake  # 繪製蛇
  end

  def update_position
    $player.position.shift  # 移動蛇的位置

    case @direction
    when 'up'
      $player.position.push([$player.position.last[0], $player.position.last[1] - 1])
      # 碰到邊界時從另一邊出現
      $player.position.last[1] = MAP_HEIGHT_UNIT_NUM if $player.position.last[1] < 0
    when 'down'
      $player.position.push([$player.position.last[0], $player.position.last[1] + 1])
      $player.position.last[1] = 0 if $player.position.last[1] > MAP_HEIGHT_UNIT_NUM
    when 'right'
      $player.position.push([$player.position.last[0] + 1, $player.position.last[1]])
      $player.position.last[0] = 0 if $player.position.last[0] > MAP_WIDTH_UNIT_NUM
    when 'left'
      $player.position.push([$player.position.last[0] - 1, $player.position.last[1]])
      $player.position.last[0] = MAP_WIDTH_UNIT_NUM if $player.position.last[0] < 0
    end
  end

  def draw_snake
    @position.each do |position|
      # Ruby2D 的 Square 類似於 JS 的 Canvas 繪製方法
      Square.new(x: position[0] * UNIT_SIZE, y: position[1] * UNIT_SIZE, size: UNIT_SIZE - 1, color: 'white')
    end
  end
end

on :key_down do |event|
  # 使用鍵盤方向鍵控制蛇的方向
  if ['up', 'down', 'left', 'right'].include?(event.key)
    case $player.direction
    when 'up'
      $player.direction = event.key unless event.key == 'down'
    when 'down'
      $player.direction = event.key unless event.key == 'up'
    when 'right'
      $player.direction = event.key unless event.key == 'left'
    when 'left'
      $player.direction = event.key unless event.key == 'right'
    end
  elsif event.key == 'return'
    $game_rule.on_enter_down  # 按下Enter鍵控制遊戲狀態
  end
end
```

### rakefile.rb

```ruby
task :default do
  puts "執行Greedy Snake小遊戲..."
  ruby "Main.rb"  # 執行主遊戲程式
end
```

### tip.rb

```ruby
class Tip
  attr_accessor :current_tip

  def initialize
    @welcome_tip = "Welcome to Greedy Snake! (Press 'Enter' to Start...)"  # 歡迎提示
    @playing_tip = "Score: (#{$game_rule.score}) (Press 'Enter' to Exit...)"  # 遊戲進行中的提示
    @death_tip = "Game Over! (Press 'Enter' to Restart...)"  # 遊戲結束提示
    @current_tip = @welcome_tip  # 當前提示設為歡迎提示
    @score_cache = $game_rule.score  # 緩存分數
  end

  def update
    detect_score  # 檢測分數變化
  end

  def detect_score
    if $game_rule.score != @score_cache
      @playing_tip = "Score: (#{$game_rule.score}) (Press 'Enter' to Exit...)"  # 更新分數提示
      @score_cache = $game_rule.score
    end
  end

  def draw_tip
    change_tip  # 根據遊戲狀態改變提示
    Text.new(current_tip, color: 'green', x: 10, y: 10, size: 18)  # 繪製提示
  end

  def change_tip
    case $game_rule.game_state
    when 'wait'
      @current_tip = @welcome_tip
    when 'playing'
      @current_tip = @playing_tip
    when 'death'
      @current_tip = @death_tip
    end
  end
end
```

### 總結
這段程式碼的結構與你可能在JavaScript或Swift中看到的相似。類似的概念在不同的語言中也存在，例如類別、方法、屬性和迴圈。理解這些程式碼後，你可以將這些知識應用到其他語言中。希望這些註解能夠幫

助你更好地理解這段Ruby程式碼。如果有其他問題，請隨時告訴我！