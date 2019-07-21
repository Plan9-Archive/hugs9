module Paths_HaXml (
	version,
	getBinDir, getLibDir, getDataDir, getLibexecDir,
	getDataFileName
	) where

import Data.Version

version = Version {versionBranch = [1,17], versionTags = []}

bindir     = "/usr/bin"
libdir     = "/usr/lib/hugs/packages/HaXml"
datadir    = "/usr/share/HaXml-1.17"
libexecdir = "/usr/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = return bindir
getLibDir = return libdir
getDataDir = return datadir
getLibexecDir = return libexecdir

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = return (datadir ++ "/" ++ name)
