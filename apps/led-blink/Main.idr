{-
Copyright 2018, Mokshasoft AB (mokshasoft.com)

This software may be distributed and modified according to the terms of
the BSD 2-Clause license. Note that NO WARRANTY is provided.
See "LICENSE_BSD2.txt" for details.
-}

module Main

import StarterWareFree.Drivers
import StarterWareFree.Platform

setupGpio : IO ()
setupGpio = do
    -- Enabling functional clocks for GPIO1 instance
    GPIO1ModuleClkConfig

    -- Selecting GPIO1[23] pin for use
    GPIO1Pin23PinMuxSetup

    -- Enabling the GPIO module
    GPIOModuleEnable GPIO_INSTANCE_ADDRESS

    -- Resetting the GPIO module
    GPIOModuleReset GPIO_INSTANCE_ADDRESS

    -- Setting the GPIO pin as an output pin
    GPIODirModeSet
        GPIO_INSTANCE_ADDRESS
        GPIO_INSTANCE_PIN_NUMBER
        GPIO_DIR_OUTPUT

blinkLed : IO ()
blinkLed = do
    -- Driving a logic HIGH on the GPIO pin
    GPIOPinWrite
        GPIO_INSTANCE_ADDRESS
        GPIO_INSTANCE_PIN_NUMBER
        GPIO_PIN_HIGH

    Delay ONOFFTIME

    -- Driving a logic LOW on the GPIO pin
    GPIOPinWrite
        GPIO_INSTANCE_ADDRESS
        GPIO_INSTANCE_PIN_NUMBER
        GPIO_PIN_LOW

    Delay ONOFFTIME

    -- Repeat blink
    blinkLed

main : IO ()
main = do
    setupGpio
    blinkLed
