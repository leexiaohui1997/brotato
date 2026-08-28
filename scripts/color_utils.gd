class_name ColorUtils

# ===== 背景色参数 =====
# Hover 亮度提升量
const HOVER_LIGHTNESS_DELTA := 0.08
# Active 亮度降低量
const ACTIVE_LIGHTNESS_DELTA := -0.08
# Disabled 饱和度目标值
const DISABLED_SATURATION := 0.20
# Disabled 明度目标值
const DISABLED_VALUE := 0.70

# ===== 边框色参数 =====
# 边框相对背景色的亮度偏移
const BORDER_LIGHTNESS_DELTA := -0.12
# Hover 边框相对 Hover 背景的偏移
const BORDER_HOVER_LIGHTNESS_DELTA := -0.12
# Active 边框相对 Active 背景的偏移
const BORDER_ACTIVE_LIGHTNESS_DELTA := -0.12
# Disabled 边框饱和度
const BORDER_DISABLED_SATURATION := 0.10
# Disabled 边框明度
const BORDER_DISABLED_VALUE := 0.60

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
	LEGEND,
	## 伤害
	DAMAGE,
	## 格挡
	BLOCKED,
	## 暴击
	CRITICAL,
	## 回复
	STEAL
}

# 色值预设
const COLOR_PRESETS: Dictionary[ColorType, Color] = {
	ColorType.DEFAULT: "#04aacf",
	ColorType.COMMON: "#38ba00",
	ColorType.RARE: "#8902c2",
	ColorType.EPIC: "#c1a103",
	ColorType.LEGEND: "#c13303",
	ColorType.DAMAGE: "#ffffff",
	ColorType.BLOCKED: "#ff4a74",
	ColorType.CRITICAL: "#fec761",
	ColorType.STEAL: "#00a07b"
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

## 根据状态色值生成边框色值
static func generate_border_colors(colors: Dictionary) -> Dictionary:
	var h = colors.normal.h
	var s = colors.normal.s
	var v = colors.normal.v

	var normal := Color.from_hsv(h, s, clampf(v + BORDER_LIGHTNESS_DELTA, 0.0, 1.0))
	var hover := Color.from_hsv(h, s, clampf(colors.hover.v + BORDER_HOVER_LIGHTNESS_DELTA, 0.0, 1.0))
	var pressed := Color.from_hsv(h, s, clampf(colors.pressed.v + BORDER_ACTIVE_LIGHTNESS_DELTA, 0.0, 1.0))
	var disabled := Color.from_hsv(h, BORDER_DISABLED_SATURATION, BORDER_DISABLED_VALUE)
	
	return {
		"normal": normal,
		"hover": hover,
		"pressed": pressed,
		"disabled": disabled
	}
