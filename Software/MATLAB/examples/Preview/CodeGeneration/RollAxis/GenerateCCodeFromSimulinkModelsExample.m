%% Generate C Code from Simulink Models
% This example shows you how to generate C code from a Simulink(R) model of a
% roll axis autopilot algorithm by using the Embedded Coder(R) product.
%
% Use the Embedded Coder product to generate C or C++ code that is
% optimized for deployment on rapid-prototyping boards, embedded
% processors, or microprocessors. If you are new to Embedded Coder or your
% application code customization requirements are minimal, you can use
% graphical tools and default code configuration settings to quickly
% generate production-quality code. If you need to produce customized code
% for integration with existing external code or you want to meet code
% guidelines and standards, tooling is available to configure the code
% generator to meet requirements for interfacing, code appearance,
% packaging, and optimizations.
%
% Generating and reviewing code for deployment to an embedded system can be
% as simple as preparing the model for code generation with the Quick Start
% tool. Then, with code tools accessible from the Simulink Editor, you can
% configure code interfaces, initiate code generation, and review the
% generated code.
%
% Copyright 2022 The MathWorks, Inc.

%% Example Models
% The tutorial uses example models |RollAxisAutopilot| and
% |RollAxisAutopilotHarness|. The model |RollAxisAutopilot| is configured to 
% use a data code interface. For a comparison between data and service code 
% interfaces and links to more information about data interfaces, see 
% <docid:ecoder_ug#mw_8e8fc629-496a-4e4e-b896-42a50ce67551 Choose Code Interface 
% for Code Generation>.
% 
% The models have been verified for simulation.
%%
% Open model |RollAxisAutopilot|. 
open_system('RollAxisAutopilot.slx')

%%
% This model implements a basic roll axis autopilot algorithm, which
% controls the aileron position of an aircraft.
%
% <<../aileron.png>>
%
%%
% The model represents one component in the greater control system of an
% aircraft. Through the |HDG_Mode| signal, the control system places the
% model in one of two operating modes: roll attitude hold or heading hold.
% The |RollAngleReference| and |HeadingMode| subsystems calculate a roll
% attitude setpoint that supports one of the operating modes. 
open_system('RollAxisAutopilot/RollAngleReference')
%%
open_system('RollAxisAutopilot/HeadingMode')
%%
% Then, the
% |BasicRollMode| subsystem, a PID controller, calculates an aileron
% position command based on the setpoint and on feedback that indicates the
% measured roll attitude and rate of change. The model is designed to
% operate at 40 Hz.
open_system('RollAxisAutopilot/BasicRollMode')
%%
% The tutorial uses model |RollAxisAutopilotHarness| to test
% |RollAxisAutopilot|.
%%
% You will learn how to:
%
% # Generate code by using the Embedded Coder Quick Start tool.
% # Configure the data interface.
% # Configure a model parameter as a global variable for tuning during run time.
% # Compare model simulation and generated code results for numeric equivalency.
% # Deploy the generated code.
%
%%
% To start the tutorial, see <docid:ecoder_gs#bt1ukd8 Generate Code by Using Embedded Coder Quick Start>.
