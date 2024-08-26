-- Create the 'users' table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    fcmtoken TEXT,
    webfcmtoken TEXT,
    notif BOOLEAN DEFAULT TRUE
);

-- Create the 'rooms' table
CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    roomid VARCHAR(255) UNIQUE NOT NULL,
    roomname VARCHAR(255)
);

-- Create the 'messages' table
CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    content BYTEA NOT NULL,
    sender INT REFERENCES users(id) ON DELETE CASCADE,
    receiver VARCHAR(255) REFERENCES rooms(roomid) ON DELETE CASCADE,
    istext BOOLEAN DEFAULT TRUE,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    sendername VARCHAR(255) NOT NULL,
    uniqueid VARCHAR(255) UNIQUE NOT NULL,
    replyto TEXT
);

-- Create the 'room_user' table to manage the users in rooms
CREATE TABLE IF NOT EXISTS room_user (
    id SERIAL PRIMARY KEY,
    userid INT REFERENCES users(id) ON DELETE CASCADE,
    roomid VARCHAR(255) REFERENCES rooms(roomid) ON DELETE CASCADE,
    UNIQUE(userid, roomid)
);

-- Create indexes for optimization
CREATE INDEX IF NOT EXISTS idx_roomid ON rooms(roomid);
CREATE INDEX IF NOT EXISTS idx_receiver ON messages(receiver);
CREATE INDEX IF NOT EXISTS idx_userid ON room_user(userid);
CREATE INDEX IF NOT EXISTS idx_roomid_userid ON room_user(roomid);
