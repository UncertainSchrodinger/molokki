use std::{io, result};

pub type Result<T> = result::Result<T, Error>;

#[derive(Debug)]
pub struct Error(Box<ErrorKind>);

impl Error {
    pub fn new(kind: ErrorKind) -> Error {
        Error(Box::new(kind))
    }
}

#[derive(Debug)]
pub enum ErrorKind {
    /// I/O related error
    Io(io::Error),

    /// Templating related errors
    TemplateError(tera::Error),

    /// Mostly unknown errors, which should be refactored to more concrete types
    Other(String),
}

impl From<io::Error> for Error {
    fn from(err: io::Error) -> Error {
        Error::new(ErrorKind::Io(err))
    }
}

impl From<tera::Error> for Error {
    fn from(err: tera::Error) -> Error {
        Error::new(ErrorKind::TemplateError(err))
    }
}

impl From<&str> for Error {
    fn from(err: &str) -> Error {
        Error::new(ErrorKind::Other(err.to_owned()))
    }
}
