# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'

# 遊戲規則類別藍圖
class GameRule
  # 賦權以取用其他實例的資料
  attr_accessor :game_state
  attr_accessor :score

  # 負責初始化相關數據，會自動被呼叫
  def initialize
    @game_state = 'wait'
    @score = 0
  end

  # 每次遊戲迴圈都會被呼叫
  def update
    detect_death
  end

  # 偵測玩家是否有死亡
  def detect_death  
    $player.position[0...-1].each do |element|
      if element == $player.position.last
        $game_rule.game_state = 'death'
        break
      end
    end
  end

  # 當按下Enter鍵的處理
  def on_enter_down
    case $game_rule.game_state
    when 'wait'
      start
    when 'playing'
      exit
    when 'death'
      restart
    end
  end

  # 遊戲開始時
  def start
    $game_rule.game_state = 'playing'
  end

  # 遊戲重新開始時
  def restart
    $main = Main.new
    start
  end

  # 結束遊戲時
  def exit
    Window.close
  end

  # 分數加一分
  def add_score
    $game_rule.score = $game_rule.score + 1
  end
end