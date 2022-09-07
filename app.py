from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def main_page():
    return "HOME PAGE" # Set up home page as you wish


# ONLINE EXPERIMENT PAGE
@app.route('/online-experiment/')
def online_experiment():
    return render_template('online_experiment.html')

# Subpages
@app.route('/online-experiment/training')
def training():
    return render_template('training.html')

@app.route('/online-experiment/practice')
def practice():
    return render_template('practice.html')

@app.route('/online-experiment/main-experiment')
def main_experiment():
    return render_template('main_experiment.html')


if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=5002)

