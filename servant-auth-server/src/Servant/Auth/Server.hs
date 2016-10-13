module Servant.Auth.Server
  (
  -- | This package provides implementations for some common authentication
  -- methods. Authentication yields a trustworthy (because generated by the
  -- server) value of an some arbitrary type:
  --
  -- > type MyApi = Protected
  -- >
  -- > type Protected = Auth '[JWT, Cookie] User :> Get '[JSON] UserAccountDetails
  -- >
  -- > server :: Server Protected
  -- > server (Authenticated usr) = ... -- here we know the client really is
  -- >                                  -- who she claims to be
  -- > server _ = throwAll err401
  --
  -- Additional configuration happens via 'Context'.

  ----------------------------------------------------------------------------
  -- * Auth
  -- | Basic types
    Auth
  , AuthResult(..)

  ----------------------------------------------------------------------------
  -- * JWT
  -- | JSON Web Tokens (JWT) are a compact and secure way of transferring
  -- information between parties. In this library, they are signed by the
  -- server (or by some other party posessing the relevant key), and used to
  -- indicate the bearer's identity or authorization.
  --
  -- Arbitrary information can be encoded - just declare instances for the
  -- 'FromJWT' and 'ToJWT' classes. Don't go overboard though - be aware that
  -- usually you'll be trasmitting this information on each request (and
  -- response!).
  --
  -- Note that, while the tokens are signed, they are not encrypted. Do not put
  -- any information you do not wish the client to know in them!

  -- ** Combinator
  -- | Re-exported from 'servant-auth'
  , JWT

  -- ** Classes
  , FromJWT(..)
  , ToJWT(..)

  -- ** Related types
  , IsMatch(..)

  -- ** Settings
  , JWTSettings(..)
  , defaultJWTSettings


  ----------------------------------------------------------------------------
  -- * Cookie
  -- | Cookies are also a method of identifying and authenticating a user. They
  -- are particular common when the client is a browser

  -- ** Combinator
  -- | Re-exported from 'servant-auth'
  , Cookie

  -- ** Settings
  , CookieSettings(..)
  , defaultCookieSettings
  , makeCookie
  , makeCookieBS


  -- ** Related types
  , IsSecure(..)

  , AreAuths

  ----------------------------------------------------------------------------
  -- * BasicAuth
  -- ** Combinator
  -- | Re-exported from 'servant-auth'
  , BasicAuth

  -- ** Classes
  , FromBasicAuthData(..)

  -- ** Settings
  , BasicAuthCfg

  -- ** Related types
  , BasicAuthData(..)
  , IsPasswordCorrect(..)

  ----------------------------------------------------------------------------
  -- * Utilies
  , ThrowAll(throwAll)
  , generateKey
  , makeJWT

  -- ** Re-exports
  , Default(def)
  , SetCookie
  ) where

import Data.Default.Class                       (Default (def))
import Servant.Auth
import Servant.Auth.Server.Internal             ()
import Servant.Auth.Server.Internal.BasicAuth
import Servant.Auth.Server.Internal.Class
import Servant.Auth.Server.Internal.ConfigTypes
import Servant.Auth.Server.Internal.Cookie
import Servant.Auth.Server.Internal.JWT
import Servant.Auth.Server.Internal.ThrowAll
import Servant.Auth.Server.Internal.Types
import Servant.Auth.Server.Internal.Orphans.SetCookie ()

import Crypto.JOSE as Jose
import Servant     (BasicAuthData (..))
import Web.Cookie  (SetCookie)

-- | Generate a key suitable for use with 'defaultConfig'.
generateKey :: IO Jose.JWK
generateKey = Jose.genJWK $ Jose.OctGenParam 256
