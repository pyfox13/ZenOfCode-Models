"""
Public API for zenofcode_models.

Only expose ORM base classes and domain models here.
Internal layout (modules, folders) is considered private.
"""

from .models.course import CourseBase

__all__ = [
    "CourseBase",
]
