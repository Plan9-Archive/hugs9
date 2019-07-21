module Paths_xhtml (
	version,
	getBinDir, getLibDir, getDataDir, getLibexecDir,
	getDataFileName
	) where

import Data.Version

version = Version {versionBranch = [2006,9,13], versionTags = []}

bindir     = "/usr/bin"
libdir     = "/usr/lib/hugs/packages/xhtml"
datadir    = "/usr/share/xhtml-2006.9.13"
libexecdir = "/usr/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = return bindir
getLibDir = return libdir
getDataDir = return datadir
getLibexecDir = return libexecdir

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = return (datadir ++ "/" ++ name)
