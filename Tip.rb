# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'

# 提示文字類別藍圖
class Tip
  # 賦權以取用其他實例的資料
  attr_accessor :current_tip

  # 負責初始化相關數據，會自動被呼叫
  def initialize
    @welcome_tip = 'Welcome to Greedy Snake ! (Press \'Enter\' to Start...)'
    @playing_tip = "Score: (#{$game_rule.score}) (Press \'Enter\' to Exit...)"
    @death_tip = 'Game Over ! (Press \'Enter\' to Restart...)'
    @current_tip = @welcome_tip
    @score_cache = $game_rule.score
  end

  # 每次遊戲迴圈都會被呼叫
  def update
    detect_score
  end

  # 隨時更新視窗上方的分數
  def detect_score
    if $game_rule.score != @score_cache
      @playing_tip = "Score: (#{$game_rule.score}) (Press \'Enter\' to Exit...)"
      @score_cache = $game_rule.score
    end
  end

  # 繪製提示文字
  def draw_tip
    change_tip
    Text.new(current_tip, color: "green", x: 10, y: 10, size: 18)
  end

  # 根據遊戲狀態，改變提示文字內容
  def change_tip
    case $game_rule.game_state
    when 'wait'
      $tip.current_tip = @welcome_tip
    when 'playing'
      $tip.current_tip = @playing_tip
    when 'death'
      $tip.current_tip = @death_tip
    end
  end
end