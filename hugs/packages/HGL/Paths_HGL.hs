module Paths_HGL (
	version,
	getBinDir, getLibDir, getDataDir, getLibexecDir,
	getDataFileName
	) where

import Data.Version

version = Version {versionBranch = [3,1], versionTags = []}

bindir     = "/usr/bin"
libdir     = "/usr/lib/hugs/packages/HGL"
datadir    = "/usr/share/HGL-3.1"
libexecdir = "/usr/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = return bindir
getLibDir = return libdir
getDataDir = return datadir
getLibexecDir = return libexecdir

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = return (datadir ++ "/" ++ name)
