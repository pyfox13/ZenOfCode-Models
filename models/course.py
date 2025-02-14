from sqlalchemy import Column, Integer, String, Text

from .base import Base  # Inherit from Base class


class CourseBase(Base):
    __tablename__ = "courses"

    # Define common fields for all courses
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)

    def __repr__(self):
        return f"<CourseBase(name={self.name})>"
