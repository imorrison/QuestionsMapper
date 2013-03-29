CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  lname VARCHAR(40),
  fname VARCHAR(40),
  is_instructor INTEGER,
  CHECK (is_instructor IN (0, 1))
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title  VARCHAR(40),
  body   TEXT,
  author_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id     INTEGER,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id)     REFERENCES users    (id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  parent_id INTEGER,
  body TEXT,
  author_id INTEGER,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(author_id)  REFERENCES users(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id)
);


CREATE TABLE question_actions (
  id INTEGER PRIMARY KEY,
  type VARCHAR(8),
  question_id INTEGER,
  time_stamp TEXT,

  CHECK (type IN ('redact', 'close', 'reopen')),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id     INTEGER,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id)     REFERENCES users    (id)
);
