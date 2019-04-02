--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<$>))
import Control.Monad (forM_)
import Data.Monoid (mappend)
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime)
import Hakyll
import Data.Time.Format (defaultTimeLocale)

--------------------------------------------------------------------------------

main :: IO ()
main = do
    let startYear = "2019"
    year <- formatTime defaultTimeLocale "%Y" <$> getCurrentTime
    let copyrightYears = if startYear == year then year else startYear ++ "-" ++ year
    hakyll $ do

        -- everytime we generate the site we update the
        -- copyright year
        let gametimeContext = constField "copyright-year" copyrightYears
                `mappend` defaultContext

        match ("img/**" .||. "favicon.ico" .||. "file/**") $ do
            route   idRoute
            compile copyFileCompiler

        match "css/*" $ do
            route   idRoute
            compile compressCssCompiler

        forM_ pages $ \page ->
            match page $ do
                route $ setExtension "html"
                compile $ do
                    getResourceBody
                        >>= loadAndApplyTemplate "templates/default.html"
                                gametimeContext
                        >>= relativizeUrls

        match "404.html" $ do
            route idRoute
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html"
                    gametimeContext

        match "templates/*" $ compile templateCompiler

pages =
    [ "jobs.html"
    , "index.html"
    , "problem.html"
    ]
