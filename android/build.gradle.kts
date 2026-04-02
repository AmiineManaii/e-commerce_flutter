allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                // Use reflection to set namespace if it's missing and the property exists
                try {
                    val namespaceMethod = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = namespaceMethod.invoke(android)
                    if (currentNamespace == null) {
                        val setNamespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                        setNamespaceMethod.invoke(android, "com.example.e_commerce.${project.name.replace(":", ".")}")
                    }
                } catch (e: Exception) {
                    // Fallback or ignore if the method doesn't exist
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
