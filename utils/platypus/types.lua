-- types.lua
-- EmmyLua/LuaLS type definitions for the Platypus module + the enhanced wrapper.
-- Put this somewhere your Lua language server can see (eg: /src/types.lua),
-- or alongside the libraries if your tooling picks them up automatically.

---@meta

--------------------------------------------------------------------------------
-- Common helper types
--------------------------------------------------------------------------------

---@alias hash userdata
---@alias vector3 userdata
---@alias vector4 userdata

---@alias PlatypusDirection
---| 1  -- DIR_UP
---| 2  -- DIR_LEFT
---| 4  -- DIR_RIGHT
---| 8  -- DIR_DOWN
---| 15 -- DIR_ALL

--------------------------------------------------------------------------------
-- platypus.lua (library)
--------------------------------------------------------------------------------

---@class PlatypusModule
---@field FALLING hash
---@field GROUND_CONTACT hash
---@field WALL_CONTACT hash
---@field WALL_JUMP hash
---@field WALL_SLIDE hash
---@field DOUBLE_JUMP hash
---@field JUMP hash
---@field SEPARATION_RAYS hash
---@field SEPARATION_SHAPES hash
---@field DIR_UP PlatypusDirection
---@field DIR_LEFT PlatypusDirection
---@field DIR_RIGHT PlatypusDirection
---@field DIR_DOWN PlatypusDirection
---@field DIR_ALL PlatypusDirection
---@field create fun(config: PlatypusConfig): PlatypusInstance
local platypus = {}

---@class PlatypusJumpConfig
---@field coyote_time number?  -- seconds (wrapper uses)
---@field buffer_time number?  -- seconds (wrapper uses)

---@class PlatypusJumpTimerState
---@field timer ManualTimer

---@class PlatypusJumpBufferState : PlatypusJumpTimerState
---@field power number|nil

---@class PlatypusJumpState
---@field status number
---@field coyote PlatypusJumpTimerState
---@field buffer PlatypusJumpBufferState

---@class PlatypusCollisionsConfig
---@field groups table<hash, PlatypusDirection> -- collision group -> allowed directions
---@field left number   -- distance to left edge of collision shape
---@field right number  -- distance to right edge of collision shape
---@field top number    -- distance to top edge of collision shape
---@field bottom number -- distance to bottom edge of collision shape
---@field offset vector3? -- collision origin offset (default 0,0,0)
---@field separation hash? -- deprecated; raycast separation only in this version

---@class PlatypusConfig
---@field collisions PlatypusCollisionsConfig
---@field wall_jump_power_ratio_y number?
---@field wall_jump_power_ratio_x number?
---@field allow_wall_jump boolean?
---@field const_wall_jump boolean?
---@field allow_double_jump boolean?
---@field allow_wall_slide boolean?
---@field wall_slide_gravity number?
---@field max_velocity number?
---@field gravity number?
---@field debug boolean?
---@field reparent boolean?
---@field separation hash? -- deprecated (moved into collisions)

---@class PlatypusInstance
---@field velocity vector3
---@field gravity number
---@field max_velocity number|nil
---@field wall_jump_power_ratio_y number
---@field wall_jump_power_ratio_x number
---@field allow_double_jump boolean
---@field allow_wall_jump boolean
---@field const_wall_jump boolean
---@field allow_wall_slide boolean
---@field wall_slide_gravity number
---@field collisions PlatypusCollisionsConfig
---@field debug boolean|nil
---@field reparent boolean
---@field set_collisions fun(collisions: PlatypusCollisionsConfig)
---@field left fun(velocity: number)
---@field right fun(velocity: number)
---@field up fun(velocity: number)
---@field down fun(velocity: number)
---@field move fun(velocity: vector3)
---@field abort_wall_slide fun()
---@field jump fun(power: number)
---@field force_jump fun(power: number)
---@field abort_jump fun(reduction: number|nil)
---@field is_jumping fun(): boolean
---@field is_wall_jumping fun(): boolean
---@field is_wall_sliding fun(): boolean
---@field is_falling fun(): boolean
---@field has_ground_contact fun(): boolean
---@field has_ceiling_contact fun(): boolean
---@field has_wall_contact fun(): boolean
---@field update fun(dt: number)
---@field on_message fun(message_id: hash, message: table)
---@field toggle_debug fun()

--------------------------------------------------------------------------------
-- platypus_enhanced.lua (your wrapper)
--------------------------------------------------------------------------------

---@class PlatypusEnhancedModule : PlatypusModule
---@field create fun(config: PlatypusEnhancedConfig): PlatypusEnhancedInstance
local platypus_enhanced = {}

---@class PlatypusEnhancedConfig : PlatypusConfig
---@field jump_config PlatypusJumpConfig?

---@class PlatypusEnhancedInstance : PlatypusInstance
---@field jump_config PlatypusJumpConfig
---@field jump_state PlatypusJumpState
---@field jump_pressed fun(power: number): boolean -- returns true if jump executed immediately
---@field jump_released fun()
---@field get_jump_timers fun(): { coyote_left: number, buffer_left: number }

return {
  platypus = platypus,
  platypus_enhanced = platypus_enhanced,
}
