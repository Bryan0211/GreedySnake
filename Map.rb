# 說明這份程式碼檔案，還會需要哪些其他檔案！
require 'ruby2d'

# 地圖每一塊磁磚的大小
UNIT_SIZE = 20

# 地圖寬大小
WINDOW_WIDTH = 640

# 地圖長大小
WINDOW_HEIGHT = 480

# 地圖寬共有多少塊磁磚
MAP_WIDTH_UNIT_NUM = WINDOW_WIDTH/UNIT_SIZE

# 地圖長共有多少塊磁磚
MAP_HEIGHT_UNIT_NUM = WINDOW_HEIGHT/UNIT_SIZE

# 視窗類別藍圖，負責管理遊戲視窗的各種設定
class Map
  # 負責初始化相關數據，會自動被呼叫
  def initialize
    Window.set(title: "Greedy Snake", MAP_WIDTH: WINDOW_WIDTH, MAP_HEIGHT: WINDOW_HEIGHT)
    Window.set(background: 'navy')
  end
end