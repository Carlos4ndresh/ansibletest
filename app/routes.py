from flask import render_template, request, redirect
from app import app, db, models


@app.route('/', methods=['GET', 'POST'])
@app.route("/index", methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form.get('name')
        favorite_color = request.form.get('color')
        cat_or_dog = request.form.get('animal')
        entry = models.Preferences(
            name=name, favorite_color=favorite_color, cat_or_dog=cat_or_dog)
        db.session.add(entry)
        db.session.commit()
    prefs = models.Preferences.query.all()
    return render_template('index.html', preferences=prefs)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
