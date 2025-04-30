# models/course.py
from sqlalchemy import Column, Integer, String

from models.base import Base


class Course(Base):
    """
    Course model representing a course entity.

    Attributes:
        id (int): The unique identifier for the course.
        name (str): The name of the course.
        description (str): A brief description of the course.
    """

    __tablename__ = "courses"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=True)

    def __repr__(self):
        return f"<Course(id={self.id}, name='{self.name}')>"
