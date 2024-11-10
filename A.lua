local run = game:GetService("RunService")
local ts = game:GetService("TweenService")

local submarine = workspace:WaitForChild("Submarine")

local rollti = TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local yawti = TweenInfo.new(19, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local pitchti = TweenInfo.new(24, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local subti = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local bumpinti = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local bumpoutti = TweenInfo.new(3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local targetXRot = script.TargetXRot
local targetYRot = script.TargetYRot
local targetZRot = script.TargetZRot

local tweenRoll = ts:Create(targetXRot, rollti, {Value = 5})
local tweenYaw = ts:Create(targetYRot, yawti, {Value = 10})
local tweenPitch = ts:Create(targetYRot, pitchti, {Value = 8})

tweenRoll:Play()
tweenYaw:Play()
tweenPitch:Play()

local tween: Tween

run.Stepped:Connect(function(time: number, deltaTime: number)
	local brx, bry, brz = script.RealBumpCFrame.Value:ToEulerAnglesXYZ()
	local bumpAngles = CFrame.Angles(brx, bry, brz)
	
	local target = CFrame.new(0, 0, 0)
		* CFrame.Angles(
			math.rad(targetXRot.Value), 
			math.rad(targetYRot.Value),
			math.rad(targetZRot.Value))
		* bumpAngles
	
	submarine:PivotTo(script.SubmarineCFrame.Value)
	
	tween = ts:Create(script.SubmarineCFrame, subti, {Value = target})
	tween:Play()
end)

local bumpTween: Tween

script.BumpCFrame.Changed:Connect(function(value: CFrame)
	bumpTween = ts:Create(script.RealBumpCFrame, bumpinti, {Value = value})
	bumpTween:Play()
	bumpTween.Completed:Wait()
	bumpTween = ts:Create(script.RealBumpCFrame, bumpoutti, {Value = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)})
	bumpTween:Play()
end)
