INSERT INTO users ('fname', 'lname', 'is_instructor')
VALUES  ('The', 'Dude', 0),
        ('Maude', 'Lebowski', 1),
        ('Walter', 'Sobchak', 0),
        ('Jeffrey', 'Lebowski', 1),
        ('Bunny', 'Lebowski', 0),
        ('Donny', 'Kerabatos', 0),
        ('Jackie', 'Treehorn', 0),
        ('Jesus', 'Quintana', 1);

INSERT INTO questions ('title', 'body', 'author_id')
VALUES  ('Who took my rug?', 'It really tied the room together.', 1),
        ('How does that taste?', 'The bowling alley is my domain? I am the king, right?', 8);

INSERT INTO question_followers ('question_id', 'user_id')
VALUES  (1, 3),
        (2, 5),
        (2, 3),
        (2, 6),
        (1, 4);

INSERT INTO replies ('question_id', 'parent_id', 'body, author_id')
VALUES  (1, NULL, 'Perhaps Jackie Treehorn', 3),
        (2, NULL, 'Not so good', 6),
        (1, 1,    'Not me!', 7);

INSERT INTO question_actions ('type', 'question_id', 'time_stamp')
VALUES  ('redact', 1, '1984-08-16 24:30:00'),
        ('close' , 1, '1984-08-17 12:30:00'),
        ('reopen', 1, '1985-08-16 24:30:00');

INSERT INTO question_likes ('question_id', 'user_id')
VALUES  (1, 3),
        (1, 4),
        (2, 4),
        (2, 6),
        (2, 1);