module Paths_unix (
	version,
	getBinDir, getLibDir, getDataDir, getLibexecDir,
	getDataFileName
	) where

import Data.Version

version = Version {versionBranch = [2,0], versionTags = []}

bindir     = "/usr/bin"
libdir     = "/usr/lib/hugs/packages/unix"
datadir    = "/usr/share/unix-2.0"
libexecdir = "/usr/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = return bindir
getLibDir = return libdir
getDataDir = return datadir
getLibexecDir = return libexecdir

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = return (datadir ++ "/" ++ name)
