platform :ios, "7.0"

inhibit_all_warnings!

target :Humid2 do
    pod 'NXVLogFormatter', '~> 0.0.1'
    pod 'CocoaLumberjack', '~> 1.8.1'
    pod 'AFNetworking', '~> 2.2.1'
    pod 'AFNetworkActivityLogger', '~> 2.0.1'
    pod 'UAObfuscatedString', '~> 0.2'
    pod 'Mantle', '~> 1.4.1'
    pod 'libextobjc/EXTScope'
end

target :Humid2Tests, :exclusive => true do
    # pod 'Kiwi'
    pod 'Specta'
    pod 'Expecta'
    pod 'OHHTTPStubs', '~> 3.1.0'
end

target :Humid2UITests, :exclusive => true do
    pod 'KIF', '~> 2.0.0'
    pod 'OHHTTPStubs', '~> 3.1.0'
end
