import uuid as py_uuid

from sqlalchemy import Integer, String
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column

from zenofcode_models.models.base import Base


class CourseBase(Base):
    """
    Course model representing a course entity.

    Attributes:
        id (int): Auto-incrementing primary key.
        uuid (UUID): Stable unique identifier for external references.
        name (str): The course name.
        description (str | None): Optional course description.
    """

    __tablename__ = "courses"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)

    uuid: Mapped[py_uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        default=py_uuid.uuid4,
        unique=True,
        nullable=False,
        index=True,
    )

    name: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[str | None] = mapped_column(String, nullable=True)

    def __repr__(self):
        return f"<Course(id={self.id}, uuid={self.uuid}, name='{self.name}')>"
