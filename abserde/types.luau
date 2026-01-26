local Pack = require(script.Parent.roblox_packages.Pack)
local Promise = require(script.Parent.roblox_packages.Promise)

export type Profile<T> = {
	Open: <T>(self: Profile<T>, user: user) -> Session<T>,
	Find: <T>(self: Profile<T>, user: user) -> Session<T>?,
}

export type Session<T> = {
	Data: T,
	-- Will be true if the session has been locked by another server
	Locked: boolean,
	-- Saves data and closes the session, removing the lock and removing it from memory
	-- Only works if the session is not locked by another server
	Release: (self: Session<T>) -> Promise.Promise,
	-- Manually saves all keys in the session (that have been modified)
	-- Only works if the session is not locked by another server
	Save: (self: Session<T>) -> Promise.Promise,

	-- Atomic methods work even if the session is locked by another server
	-- Use these when you need to modify a session of a user that may not be in this server
	-- Atomically adds a value to a key in the session
	-- key is / separated and starts with a key in the profile, e.g. "Settings/Volume"
	AtomicSet: <T, U>(self: Session<T>, key: string, value: U, transactionSchema: U?) -> Promise.TypedPromise<boolean>,
	-- Atomically removes a key
	AtomicRemove: (self: Session<T>, key: string) -> Promise.TypedPromise<boolean>,
}

export type KeyOptions<T> = {
	Schema: _AbserdeSchema<T>,
	Lockable: boolean, -- [true] A locked key cannot be modified by other servers
	AutoLoad: boolean, -- [true] Automatically loads the key when the session is opened, otherwise will be loaded when indexed
}

export type Key<T> = {
	Options: KeyOptions<T>,
	Data: T,
	Default: T,
	_dirty: boolean, -- Do we have unsaved changes?
	_lastSaved: number?,
}

export type _AbserdeSchema<T> = {
	schema: Pack.Schema<T>,
	name: string,
	version: number,
}

type user = Player | number

export type Abserde = {}

type instNode<T, V> = V & T
export type AbserdeProject = instNode<Folder, {
	Schemas: instNode<Folder, {
		Snapshots: instNode<Folder, { [string]: { [string]: ModuleScript } }>,
		[string]: ModuleScript,
	}>,
	Profiles: instNode<Folder, { [string]: ModuleScript }>,
}>

return nil
