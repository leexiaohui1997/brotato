class_name ColorUtils

# Hover 亮度提升量
const HOVER_LIGHTNESS_DELTA := 0.08
# Active 亮度降低量
const ACTIVE_LIGHTNESS_DELTA := -0.08
# Disabled 饱和度目标值
const DISABLED_SATURATION := 0.20
# Disabled 明度目标值
const DISABLED_VALUE := 0.70

# 颜色类型
enum ColorType {
	## 默认
	DEFAULT,
	## 普通
	COMMON,
	## 稀有
	RARE,
	## 史诗
	EPIC,
	## 传说
	LEGEND
}

# 色值预设
const COLOR_PRESETS: Dictionary[ColorType, Color] = {
	ColorType.DEFAULT: "#04aacf",
	ColorType.COMMON: "#38ba00",
	ColorType.RARE: "#8902c2",
	ColorType.EPIC: "#c1a103",
	ColorType.LEGEND: "#c13303"
}

## 根据默认色生成所有状态色值
static func generate(base_color: Color) -> Dictionary:
	var h := base_color.h
	var s := base_color.s
	var v := base_color.v
	
	var hover_color := Color.from_hsv(h, s, clampf(v + HOVER_LIGHTNESS_DELTA, 0.0, 1.0))
	var active_color := Color.from_hsv(h, s, clampf(v + ACTIVE_LIGHTNESS_DELTA, 0.0, 1.0))
	var disabled_color := Color.from_hsv(h, DISABLED_SATURATION, DISABLED_VALUE)
	
	return {
		"normal": base_color,
		"hover": hover_color,
		"pressed": active_color,
		"disabled": disabled_color
	}
