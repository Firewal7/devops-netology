import hudson.model.*
import jenkins.model.*

def buildingJobs = Jenkins.instance.getAllItems(Job.class)

println 'List of Jobs that have been failed at least once:'

buildingJobs.each { job->
  builds = job.getBuilds()
  builds.any { item ->
    if (item.result == Result.FAILURE) {
      println '- ' + job.fullName
      return true
    }
  }

}
