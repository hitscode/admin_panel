import certifi
from pymongo import MongoClient
from passlib.context import CryptContext

# MongoDB Atlas connection string
MONGODB_CONNECTION_STRING = (
    "mongodb+srv://nfcadmin:nfcadmin123@cluster0.zqs29.mongodb.net/"
    "?retryWrites=true&w=majority&appName=Cluster0"
)

# Create the MongoClient with certificate verification
client = MongoClient(MONGODB_CONNECTION_STRING, tlsCAFile=certifi.where())

# Connect to two different databases:
# Admin data will be stored in adminPanelDB.
admin_db = client.get_database("adminPanelDB")
admin_collection = admin_db.get_collection("admins")  # For admin credentials

# Student data will be stored in college_db.
college_db = client.get_database("college_db")

# Initialize the password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def get_admin_collection():
    """Return the admin collection from adminPanelDB."""
    return admin_collection


def initialize_admin():
    """
    Check if the admin user exists in adminPanelDB.
    If not, create one with:
        Username: admin
        Password: amtics123
    """
    admin_username = "admin"
    admin_password = "amtics123"
    
    existing_admin = admin_collection.find_one({"username": admin_username})
    if not existing_admin:
        hashed_password = pwd_context.hash(admin_password)
        admin_collection.insert_one({
            "username": admin_username,
            "password": hashed_password
        })
        print("Admin user created successfully.")
    else:
        print("Admin user already exists.")


def get_college_db():
    """Return the college_db instance for student data."""
    return college_db
