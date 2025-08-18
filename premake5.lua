workspace "LearningEngine"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }


outputdir= "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir={}
IncludeDir["GLFW"]="LearningEngine/vendor/GLFW/include"
IncludeDir["Glad"]="LearningEngine/vendor/Glad/include"
IncludeDir["ImGui"]="LearningEngine/vendor/imgui"
IncludeDir["glm"]="LearningEngine/vendor/glm"
IncludeDir["spdlog"]="LearningEngine/vendor/spdlog/include"

include "LearningEngine/vendor/GLFW"
include "LearningEngine/vendor/Glad"
include "LearningEngine/vendor/imgui"

project "LearningEngine"
    location "LearningEngine"
    kind "StaticLib"
    language "C++"
    staticruntime "on"
     cppdialect "C++17"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader"gelpch.h"
    pchsource"LearningEngine/src/gelpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/glm/glm/**.hpp",
        "%{prj.name}/vendor/glm/glm/**.inl",
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{IncludeDir.spdlog}",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
        "%{IncludeDir.glm}"
    }

    links
    {
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    filter "system:windows"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL",
             "GEL_BUILD_DLL_DEBUG",
             "GLFW_INCLUDE_NONE",
             "_CRT_SECURE_NO_WARNINGS"
         }
    filter "system:macosx"
        system "macosx"
        defines
        {
            "GEL_PLATFORM_MAC",
            "GEL_BUILD_DLL",
            "GEL_BUILD_DLL_DEBUG",
            "GLFW_INCLUDE_NONE",
            "ANGEL_ENABLE_METAL"
        }
        
        links
        {
        "GL",
        "EGL",
        "Metal.framework",
        "Cocoa.framework",
        "IOKit.framework",
        "AppKit.framework",
        "QuartzCore.framework",
        "CoreFoundation.framework",
        "CoreGraphics.framework"
        }
        includedirs{
            "vendor/angle/include",
            "vendor/angle/src",
            "vendor/angle/src/libANGEL",
        }
        libdirs{"vendor/angle/out/Mac"}
    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "on"

    filter "action:vs*"
            buildoptions{"/utf-8"}
            defines {"_UNICODE", "UNICODE"}
    filter "action:xcode4"
        pchheader "../LearningEngine/src/gelpch.h"
        pchsource "../LearningEngine/src/gelpch.cpp"
        
        xcodebuildsettings{
            ["MACOSX_DEPLOYMENT_TARGET"]="10.15",
            ["CLANG_CXX_LANGUAGE_STANDARD"]="c++17",
            ["GCC_PRECOMPILE_PREFIX_HEADER"]="YES",
            ["HEADER_SEARCH_PATHS"]={
            "$(SRCROOT)/vendor/GLFW/include",
            "$(SRCROOT)/vendor/Glad/include",
            "$(SRCROOT)/vendor/spdlog/include",
            "$(SRCROOT)/vendor/angle/include",},
            ["GCC_INCREASE_PRECOMPILED_HEADER_SHARING"]="YES"
        }



project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
    }

    includedirs
    {
        "LearningEngine/src",
        "%{IncludeDir.glm}",
        "%{IncludeDir.spdlog}"
    }

    links
    {
        "LearningEngine"
    }
    filter "system:macosx"
        system "macosx"
        
        links
        {
        "Cocoa.framework",
        "IOKit.framework",
        "AppKit.framework",
        "CoreFoundation.framework",
        "CoreGraphics.framework"
        }
        includedirs{
            "vendor/angle/include",
            "vendor/angle/src",
            "vendor/angle/src/libANGEL",
        }
        
    filter "system:windows"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL"
         }


    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "on"

    filter "action:vs*"
        buildoptions{"/utf-8"}
        defines {"_UNICODE", "UNICODE"}
    filter "action:xcode4"
        xcodebuildsettings{
            ["ALWAYS_SEARCH_USER_PATHS"]="YES",
            ["CLANG_ENABLE_MODULES"]="YES"
        }
