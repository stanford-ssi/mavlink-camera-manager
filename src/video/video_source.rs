use super::types::*;
use super::video_source_usb::VideoSourceUsb;
use super::xml;
use serde::{Deserialize, Serialize};
use v4l::prelude::*;

pub trait VideoSource {
    fn name(&self) -> &String;
    fn source_string(&self) -> &String;
    fn resolutions(&self) -> Vec<FrameSize>;
    fn configure_by_name(&self, config_name: &str, value: i64) -> std::io::Result<()>;
    fn configure_by_id(&self, config_id: u64, value: i64) -> std::io::Result<()>;
    fn cameras_available() -> Vec<VideoSourceType>;
    fn controls(&self) -> Vec<Control>;
}

pub fn cameras_available() -> Vec<VideoSourceType> {
    return VideoSourceUsb::cameras_available();
}

pub fn set_control(source_string: &String, control_id: u64, value: i64) -> std::io::Result<()> {
    let cameras = cameras_available();
    let camera = cameras
        .iter()
        .find(|source| source.inner().source_string() == source_string);

    if let Some(camera) = camera {
        return camera.inner().configure_by_id(control_id, value);
    }

    let sources_available: Vec<String> = cameras
        .iter()
        .map(|source| source.inner().source_string().clone())
        .collect();

    return Err(std::io::Error::new(
        std::io::ErrorKind::NotFound,
        format!(
            "The source string '{}' does not exist, the available options are: {:?}.",
            source_string, sources_available
        ),
    ));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple_test() {
        println!("{:#?}", cameras_available());
    }
}