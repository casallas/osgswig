--
-- osgART premake script
--
-- Global settings used
-- 

-- globals
globals = {}

-- debug needs to have a suffix
globals['targetsuffix'] = "_debug"
globals['osg'] = {}
globals['openthreads'] = {}

globals.osg.two = false
globals.osg.newdllname = false

function grabcmd(cmd)
	local e = os.execute( cmd .. " > .premake.tmp")
	f = io.open(".premake.tmp")
	local s = f:read()
	f:close()
	return s
end

function grabversion(s,t)
	for d in string.gfind(s, "%d+") do
		table.insert(t,tonumber(d))
	end
	return t
end

-- check version number via osgversion
globals.init = function()

	local s = grabcmd("osgversion --version-number")
	
	globals.osg.version = {}
	
	grabversion(s,globals.osg.version)
	
	print("OpenSceneGraph Version: ".. globals.osg.version[1] .. "." .. globals.osg.version[2])
	
	-- osg
	if (globals.osg.version[1] >= 2) then 
		globals.osg.two = true
	end
	
	-- starting with 2.1.10 we have a new versioning
	if (globals.osg.version[1] >= 2 and
		globals.osg.version[2] >= 1 and
		globals.osg.version[3] >= 10)	
	then
		globals.osg.newdllname = true
		-- new build system
		-- consider openthreads 
		local s = grabcmd("osgversion --openthreads-version-number")
		
		globals.openthreads.version = {}
		globals.openthreads.version = grabversion(s,globals.openthreads.version)
		
		print("OpenThreads Version: ".. globals.openthreads.version[1] .. "." .. globals.openthreads.version[2])	
		
		-- so version is easier
		globals.openthreads.soversion = grabcmd("osgversion --openthreads-soversion-number")
		
		-- do the same for osg
		globals.osg.soversion = grabcmd("osgversion --soversion-number")	
		
	end	
end

globals.osg.libpaths = function()
	return { "$(OSG_ROOT)/lib", "$(OSG_ROOT)/lib/debug" }
end

globals.osg.dllname = function(name)
	if (globals.osg.newdllname == true) then
		return "osg" .. globals.osg.soversion .. "-" .. name
	end
	return name
end


globals.openthreads.libs = function()
	if (globals.osg.two) then
		return { "OpenThreads" }
	else
		return { "OpenThreadsWin32" }
	end
end

