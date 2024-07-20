# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'
require_relative 'Map'
require_relative 'Player'
require_relative 'GameRule'
require_relative 'Tip'
require_relative 'Item'

# 繪製速率目前為每秒10次
set fps_cap: 10

# 主程式類別藍圖，負責規劃遊戲主迴圈相關功能
class Main
  # 負責初始化相關數據，會自動被呼叫
  def initialize
    $map = Map.new
    $player = Player.new
    $game_rule = GameRule.new
    $tip = Tip.new
    $item = Item.new
  end

  # 負責管理遊戲主迴圈
  def game_loop
    # 如果遊戲開始了，才會執行內部程式碼
    if $game_rule.game_state == 'playing'
      $game_rule.update
      $player.update
      $item.update
      $tip.update
    end

    # 繪製提示文字，會根據遊戲狀態而有不同提示文字
    $tip.draw_tip
  end
end

# 實例化主程式藍圖
$main = Main.new

# 遊戲每繪製一次就會執行一次內部程式碼，無限循環直到遊戲程式結束
update do
  clear
  # 執行遊戲迴圈
  $main.game_loop
end

# 顯示遊戲視窗
show
