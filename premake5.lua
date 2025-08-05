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

include "LearningEngine/vendor/GLFW"
include "LearningEngine/vendor/Glad"
include "LearningEngine/vendor/imgui"

project "LearningEngine"
    location "LearningEngine"
    kind "SharedLib"
    language "C++"
    staticruntime "Off"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader"gelpch.h"
    pchsource"LearningEngine/src/gelpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}"
    }

    links
    {
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    filter "system:windows"
         cppdialect "C++17"
         staticruntime "Off"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL",
             "GEL_BUILD_DLL_DEBUG",
             "GLFW_INCLUDE_NONE"
         }

         postbuildcommands
         {
             ("{MKDIR} ../bin/" .. outputdir .. "/Sandbox"),
             ("{COPYFILE} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
         }

    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "On"

    filter "action:vs*"
            buildoptions{"/utf-8"}
            defines {"_UNICODE", "UNICODE"}





    project "Sandbox"
        location "Sandbox"
        kind "ConsoleApp"
        language "C++"
        staticruntime "Off"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "LearningEngine/vendor/spdlog/include",
        "LearningEngine/src"
    }

    links
    {
        "LearningEngine"
    }

    filter "system:windows"
         cppdialect "C++17"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL"
         }


    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "On"

    filter "action:vs*"
        buildoptions{"/utf-8"}
        defines {"_UNICODE", "UNICODE"}