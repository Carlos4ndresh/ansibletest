from flask import render_template, Flask, make_response, Response

app = Flask(__name__)


@app.route('/')
def hello():
    headers = {'Content-Type': 'text/html'}
    return Response(render_template('hello.html'), 200, mimetype='text/html')


if __name__ == '__main__':
    app.run(debug=True)
