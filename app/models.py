from app import db


class Preferences(db.Model):
    name = db.Column(db.String(200), unique=True)
    favorite_color = db.Column(db.String(100))
    cat_or_dog = db.Column(db.String(20))

    def __repr__(self):
        return '<Person {}>'.format(self.name)
