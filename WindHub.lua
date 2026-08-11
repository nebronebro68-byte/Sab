
local LIBRARY_URL =
    "https://raw.githubusercontent.com/nebronebro68-byte/Sab/refs/heads/main/HaroonWindUI.lua"

--==================================================
-- VALIDATE URL
--==================================================

if type(LIBRARY_URL) ~= "string"
or LIBRARY_URL == ""
or LIBRARY_URL ==
    "YOUR_LIBRARY_RAW_GITHUB_URL_HERE" then

    warn(
        "HaroonWindUI Loader:"
    )

    warn(
        "Please replace LIBRARY_URL with your RAW Lua URL."
    )

    return
end

--==================================================
-- CHECK ENVIRONMENT
--==================================================

if type(loadstring) ~= "function" then

    warn(
        "HaroonWindUI Loader: loadstring is unavailable."
    )

    return
end

if type(getgenv) ~= "function" then

    warn(
        "HaroonWindUI Loader: getgenv is unavailable."
    )

    return
end

--==================================================
-- LOAD LIBRARY
--==================================================

local HaroonWindUI

local success, err =
    pcall(function()

        -- Fetch
        local libraryCode =
            game:HttpGet(
                LIBRARY_URL
            )

        if type(libraryCode) ~= "string"
        or libraryCode == "" then

            error(
                "The downloaded library is empty."
            )
        end

        --==========================================
        -- HTML / ERROR PAGE CHECK
        --==========================================

        local lowerCode =
            libraryCode:lower()

        if lowerCode:find(
            "<html",
            1,
            true
        )
        or lowerCode:find(
            "<!doctype",
            1,
            true
        )
        or lowerCode:find(
            "404 not found",
            1,
            true
        )
        or lowerCode:find(
            "repository not found",
            1,
            true
        )
        or lowerCode:find(
            "page not found",
            1,
            true
        ) then

            error(
                "The URL returned an HTML/error page instead of Lua."
            )
        end

        --==========================================
        -- COMPILE
        --==========================================

        local chunk, compileError =
            loadstring(
                libraryCode
            )

        if not chunk then

            error(
                "Library compilation failed:\n"
                .. tostring(
                    compileError
                )
            )
        end

        --==========================================
        -- EXECUTE
        --==========================================

        local executed, executionError =
            pcall(
                chunk
            )

        if not executed then

            error(
                "Library execution failed:\n"
                .. tostring(
                    executionError
                )
            )
        end

        --==========================================
        -- GET LIBRARY
        --==========================================

        local env =
            getgenv()

        HaroonWindUI =
            env.HaroonWindUI

        if not HaroonWindUI then

            error(
                "HaroonWindUI was not found in getgenv()."
            )
        end

        if type(
            HaroonWindUI.CreateWindow
        ) ~= "function" then

            error(
                "HaroonWindUI loaded, but CreateWindow is missing."
            )
        end
    end)

--==================================================
-- ERROR
--==================================================

if not success then

    warn(
        "======================================"
    )

    warn(
        "HaroonWindUI Loader Error"
    )

    warn(
        tostring(err)
    )

    warn(
        "======================================"
    )

    return
end

--==================================================
-- SUCCESS
--==================================================

print(
    "[HaroonWindUI] Library loaded successfully."
)

print(
    "[HaroonWindUI] Version: Pro Corrected Edition"
)

--==================================================
-- OPTIONAL EXTRA USAGE
--==================================================

-- المكتبة نفسها تنشئ الـ UI تلقائياً.
-- لذلك لا تحتاج إلى CreateWindow هنا.
--
-- إذا أردت مستقبلاً فصل الـ Demo عن المكتبة،
-- يمكن جعل المكتبة لا تبدأ تلقائياً ثم استخدام:
--
-- local Window = HaroonWindUI:CreateWindow({
--     Title = "My Script",
--     SubTitle = "HaroonWindUI"
-- })
--
-- Window:Show()
