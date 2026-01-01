from zenofcode_models.models.course import CourseBase


def test_course_fields():
    course = CourseBase(name="Python 101", description="Intro course.")
    assert course.name == "Python 101"
    assert course.description == "Intro course."
