from models.course import CourseBase


def test_create_course():
    """Test creating a CourseBase instance."""
    course = CourseBase(
        name="Python Programming", description="Learn Python from scratch"
    )

    assert course.name == "Python Programming"
    assert course.description == "Learn Python from scratch"


def test_course_repr():
    """Test the string representation of the CourseBase instance."""
    course = CourseBase(name="Python Programming", description="Learn Python")
    assert repr(course) == "<CourseBase(name=Python Programming)>"


def test_optional_fields():
    """Test creating a course with only required fields."""
    course = CourseBase(name="Introduction to SQL")
    assert course.name == "Introduction to SQL"
    assert course.description is None
