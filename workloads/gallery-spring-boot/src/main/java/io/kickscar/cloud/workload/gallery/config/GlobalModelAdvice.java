package io.kickscar.cloud.workload.gallery.config;

import io.kickscar.cloud.workload.gallery.runtime.EC2InstanceIdentity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {
    private final EC2InstanceIdentity instanceIdentity;

    public GlobalModelAdvice(EC2InstanceIdentity instanceIdentity) {
        this.instanceIdentity = instanceIdentity;
    }

    @ModelAttribute("ec2InstanceId")
    public String ec2InstanceId() {
        return instanceIdentity.getInstanceId();
    }
}

