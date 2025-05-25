from dotenv import load_dotenv
from blueprints import create_app
import os


load_dotenv()

app = create_app()


app.config['UPLOAD_FOLDER'] = os.path.join('static', 'uploads')
app.config['MAX_CONTENT_LENGTH'] = 5 * 1024 * 1024  # 5 MB limit
app.config['ALLOWED_EXTENSIONS'] = {'png', 'jpg', 'jpeg', 'gif'}

os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)


# Run for Development
#if __name__ == '__main__':
#    app.run(debug=True)

 # Run for production
 # gunicorn -w 4 -b 127.0.0.1:5000 app:app


